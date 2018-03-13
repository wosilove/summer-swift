import UIKit
import AFDateHelper

class TodayViewController: UIViewController, DocumentStoreDelegate {
    @IBOutlet var tableView: UITableView!
    
    var documentStore: DocumentStore!
    
    var eventsForToday: [EventViewModel] {
        return documentStore.getEventsHappening(now: Date())
    }
    
    var nextEvent: EventViewModel? {
        return documentStore.getNextEvent(from: Date())
    }
    
    var nextCourse: CourseViewModel? {
        return documentStore.getNextCourse(from: Date())
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        documentStore.delegate = self
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 130
        
        if #available(iOS 11.0, *) {
            // table layout is fine
        }
        else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        
        if eventsForToday.count == 0 {
            self.tableView.backgroundColor = UIColor.black
            self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none
            self.tableView.isScrollEnabled = false
        }
    }
    
    // provide the initial detail view for iPad
    // must go here and not viewDidLoad because iPhone begins not collapsed
    override func viewWillAppear(_ animated: Bool) {
        if let splitViewController = self.splitViewController, !splitViewController.isCollapsed, splitViewController.displayMode == .allVisible {
            let initialIndexPath = IndexPath(row: 0, section: 0)
            self.tableView.selectRow(at: initialIndexPath, animated: true, scrollPosition:UITableViewScrollPosition.none)
            self.performSegue(withIdentifier: "showPromoDetail", sender: initialIndexPath)
            self.tableView.deselectRow(at: initialIndexPath, animated: false)
            
            // the detail view for the promo cell is designed for full screen
            splitViewController.preferredDisplayMode = .primaryHidden
        }
    }
    
    func documentsDidUpdate() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "showPromoDetail"?:
            if let promoDetailViewController = segue.destination as? PromoDetailViewController {
                promoDetailViewController.teaserTrailer = createTeaserTrailer(nextEvent: nextEvent, nextCourse: nextCourse)
            }
        case "showEvent"?:
            if let row = tableView.indexPathForSelectedRow?.row,
                let navViewController = segue.destination as? UINavigationController,
                let eventDetailViewController = navViewController.topViewController as? EventDetailViewController {
                let event = eventsForToday[row]
                eventDetailViewController.event = event
                eventDetailViewController.lecturer = documentStore.getLecturerBy(id: event.lecturerId)
            }
        default:
            preconditionFailure("Unexpected segue identifer")
        }
    }
    
    func createTeaserTrailer(nextEvent: EventViewModel?, nextCourse: CourseViewModel?) -> String {
        var teaserTrailer = String()
        if let event = nextEvent, let eventStartDate = event.startDate {
            let daysUntilNextEvent = eventStartDate.since(Date(), in: .day)
            if daysUntilNextEvent <= 1 {
                teaserTrailer = "Our next event starts tomorrow"
            }
            else if daysUntilNextEvent < 7 {
                teaserTrailer = "\(daysUntilNextEvent) days until our next event"
            }
            else if eventStartDate.compare(.isNextWeek) {
                teaserTrailer = "One week until our next event"
            }
            else {
                teaserTrailer = "\(eventStartDate.since(Date(), in: .week)) weeks until our next event"
            }
        }
        if teaserTrailer != "" {
            teaserTrailer += "\n"
        }
        if let course = nextCourse, let courseStartDate = course.startDate {
            let daysUntilNextCourse = courseStartDate.since(Date(), in: .day)
            if daysUntilNextCourse <= 1 {
                teaserTrailer += "Our next course starts tomorrow"
            }
            else if daysUntilNextCourse < 7 {
                teaserTrailer += "\(daysUntilNextCourse) days until our next course"
            }
            else if courseStartDate.compare(.isNextWeek) {
                teaserTrailer += "One week until our next course"
            }
            else {
                teaserTrailer += "\(courseStartDate.since(Date(), in: .week)) weeks until our next course"
            }
        }
        return teaserTrailer
    }
}

// MARK: - UITableViewDataSource
extension TodayViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if eventsForToday.count == 0 {
            return 1
        }
        
        return eventsForToday.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if eventsForToday.count == 0 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "PromoCell", for: indexPath) as? PromoCell {
                cell.configureWith(teaserTrailer: createTeaserTrailer(nextEvent: nextEvent, nextCourse: nextCourse))
                return cell
            }
            return UITableViewCell()
        }
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "EventCell", for: indexPath) as? EventCell {
            let event = eventsForToday[indexPath.row]
            
            cell.configureWith(event: event, lecturer: documentStore.getLecturerBy(id: event.lecturerId))
            return cell
        }
        
        return UITableViewCell()
    }
}

// MARK: - UITableViewDelegate
extension TodayViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if eventsForToday.count == 0 {
            performSegue(withIdentifier: "showPromoDetail", sender: TodayViewController())
        }
        else {
            performSegue(withIdentifier: "showEvent", sender: EventsViewController())
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
