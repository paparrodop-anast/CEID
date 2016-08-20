-- phpMyAdmin SQL Dump
-- version 4.1.14
-- http://www.phpmyadmin.net
--
-- Host: 127.0.0.1
-- Generation Time: Sep 30, 2015 at 07:00 AM
-- Server version: 5.6.17
-- PHP Version: 5.5.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Database: `webprojectdb`
--

-- --------------------------------------------------------

--
-- Table structure for table `eventsdb`
--

CREATE TABLE IF NOT EXISTS `eventsdb` (
  `id` bigint(20) NOT NULL,
  `name` varchar(255) COLLATE utf8_bin NOT NULL,
  `dateNtime` datetime NOT NULL,
  `cover_photo_url` varchar(255) COLLATE utf8_bin NOT NULL,
  `owner_name` varchar(255) COLLATE utf8_bin NOT NULL,
  `description` longtext COLLATE utf8_bin NOT NULL,
  `lat` float(10,6) NOT NULL,
  `lng` float(10,6) NOT NULL,
  `street` varchar(255) COLLATE utf8_bin NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

--
-- Dumping data for table `eventsdb`
--

INSERT INTO `eventsdb` (`id`, `name`, `dateNtime`, `cover_photo_url`, `owner_name`, `description`, `lat`, `lng`, `street`) VALUES
(895706060502836, 'LIVE :: Kontrafouris Trio (Kontrafouris - Tsakas - Ntouvas)', '2012-01-03 22:00:00', 'https://fbcdn-profile-a.akamaihd.net/hprofile-ak-xfa1/t5.0-1/372811_895706060502836_1642721942_q.jpg', '', 'Γιώργος Κοντραφούρης Hammond\nΔημήτρης Τσάκας Sax\nΣωτήρης Ντούβας Drums\n\n            (είσοδος ελεύθερη)', 38.244492, 21.735212, 'Πατρέως 80'),
(962955033749178, 'F r e s h     S u n d a y     C o c k t a i l <<Rasberry Tequila Sangria>>', '2012-02-12 21:30:00', 'https://scontent.xx.fbcdn.net/hprofile-xpf1/t5.0-1/157927_962955033749178_124319662_q.jpg', '', 'Sangria is a traditional Spanish drink that combines wine and fresh fruit. This Mexican-style sangria has a higher alcohol content than most sangrias (great for pairing with spicy foods) and is as much a margarita as it is a sangria. Always use a tasty wine when making sangria as it will be the most prominent flavor.\n Prep Time: 15 minutes\n \nTotal Time: 15 minutes\n \nIngredients:\n \n1 bottle White Wine, preferably Spanish or Sauvignon Blanc or Pinot Gris\n 1 cup silver Tequila\n 1/2 cup Triple Sec\n 1/4 cup fresh Lime Juice\n 1/4 cup Sugar\n 2 pints fresh Raspberries or 10 ounce frozen package (thawed)\n 24 ounces (2 cans) Ginger Ale\n ice\n Lime wedges, for garnish (optional', 38.244492, 21.735212, 'Πατρέως 80'),
(963725250334540, 'Νότος Jazz Bar LIVE :: <<Night and Day>> Gypsy Swing', '2012-01-30 22:30:00', 'https://scontent.xx.fbcdn.net/hprofile-xfa1/t5.0-1/373057_963725250334540_1730731240_q.jpg', '', '<<Night and Day>>\n \nGypsy Swing \n\n\n\nΜέλη\n \n\nΘωμαή Απέργη - φωνή\n Διονύσης Κανάκης - κιθάρα\n Αλέξης Μαχαίρας - μπάσο\n Νίκος Μαυρίδης - βιολί\n Ευγένιος Σκίτσας - κιθάρα \n\n\n\nΤόπος Καταγωγής\n \n\nPatras,Greece \n\n\n\n\nΒιογραφικό\n \n\nΟι Night and Day σχηματίστηκαν το 2009 στην Πάτρα από τους \nκιθαρίστες Διονύση Κανάκη και Γιώργο Φιλιππόπουλο. Αρχικά παρουσίασαν την δουλειά τους \nστα live ως guitar duo με επιρροές από Django Reinhardt ,Rosenberg trio,al di meola , paco de lucia kai jazz latin standards..Μετά από μια μικρή παύση -λόγω υποχρεώσεων - επανήλθαν το 2010 \nμε την προσθήκη στο bass τον Αλέξη Μαχαίρα στα κρουστά τον Κώστα Σπυράτο\n και vocals την Θωμαή Απέργη.Το σεπτέμβριο του 2011 άλλαξε η σύσταση λόγω υποχρεώσεων και ήρθε ο Ευγένιος Σκίτσας - κιθάρα και ο Νίκος Μαυρίδης - βιολί.Ο ήχος τους είναι μια συνθέση από gypsy swing,blues, bossa, bolero.', 38.244492, 21.735212, 'Πατρέως 80'),
(984194684976418, 'LIVE :: Blues Night (Βουτσινός-Τσινούκας-Καστάνης)', '2012-01-15 23:00:00', 'https://scontent.xx.fbcdn.net/hprofile-xpt1/t5.0-1/373510_984194684976418_197676852_q.jpg', '', 'Μπορίς Βουτσινός - Φωνή, Κιθάρα, Φυσαρμόνικα, Καζού, Μπαούλο\nΣάκης Τσινούκας - Ηλ. Κιθάρα\nΣπήλιος Καστάνης - Κοντραμπάσο \n      \n        -Είσοδος ελεύθερη-', 38.244492, 21.735212, 'Πατρέως 80'),
(1003337526351100, 'Νότος Jazz Bar LIVE :: MODERN JAZZ TRIO', '2012-01-31 22:30:00', 'https://scontent.xx.fbcdn.net/hprofile-xat1/t5.0-1/187862_1003337526351100_704861658_q.jpg', '', 'MODERN JAZZ TRIO\n   Δημήτρης Τσάκας : Σαξόφωνο\n Κώστας Κωνσταντίνου : Κοντραμπάσο\nΣωτήρης Ντούβας : Τύμπανα  \n\n      Eίσοδος ελεύθερη', 38.244492, 21.735212, 'Πατρέως 80'),
(1148303341853879, 'Ελένη Βαλεντή Quartet <Brazilian Ensemble> LIVE @ Νότος Jazz Bar', '2012-02-14 22:30:00', 'https://fbcdn-profile-a.akamaihd.net/hprofile-ak-xpf1/t5.0-1/50339_1148303341853879_918827621_q.jpg', '', 'Ελένη Βαλεντή Quartet <Brazilian Ensemble>\n\nΕλένη Βαλεντή Vocals\nΑποστόλης Λεβεντόπουλος ΚιΘάρα\nΧάρης Χαραλάμπους Μπάσο\nΣωτήρης Ντούβας Τύμπανα\n  Είσοδος ελεύθερη\n\n  Η Ελένη Βαλεντή, ελληνογερμανικής καταγωγής, γεννήθηκε στην Αθήνα το 1980 από γονείς μουσικούς, μέλη της Κρατικής  Ορχήστρας  Αθηνών .Παίρνει τα πρώτα μαθήματα μουσικής σε ηλικία πέντε χρονών και στα οκτώ της αρχίζει τις σπουδές της στο κλασσικό βιολί με καθηγητή τον πατέρα της Παναγιώτη Βαλεντή. Αργότερα συνεχίζει στο Ωδείο Αθηνών με καθηγητές τους Γιάννη Τζουμάνη και Τάτση Αποστολίδη (Κορυφαίοι Α της Κ.Ο.Α.).Ταυτόχρονα παρακολουθεί μαθήματα σολφέζ και θεωρίας. Παράλληλα με τις σπουδές στο Ωδείο Αθηνών παίρνει μαθήματα κλασσικής κιθάρας από τον Βασίλη Τιγιρίδη και τα πρώτα μαθήματα φωνητικής από τη Δέσποινα Καλαφάτη.Τελειώνει το λύκειο της Γερμανικής Σχολής Αθηνών (Deutsche Schule Athen), και το 2002 αρχίζει τις σπουδές της στο τζάζ τραγούδι, στην Ανώτατη Μουσική Σχολή της Κολωνίας (Musikhochschule Koelln), με καθηγητές τις Anette von Eichel, Susanne Schneider και τον Joachim Ulrich.  Παρακολουθεί μαθήματα αρμονίας, σύνθεσης, αυτοσχεδιασμού, σολφέζ καθώς και τζαζ πιάνου με τον Hubert Nuss. Λαμβάνει επίσης μέρος σε σεμινάρια με τους : John Taylor, Celine Rudolph, Judy Niemack, Kara Johnstad και Torun Eriksen.Από το 2002 έως το 2007 συμμετέχει σαν τραγουδίστρια στην Big Βand του Πανεπιστημίου της Κολωνίας και σε πολλά μουσικά σχήματα. Σε συνεργασία με τον κιθαρίστα Νώντα Λαδά συμμετέχει στο μουσικό σύνολο ``Alchimia´´, όπου παρουσιάζουν δικές τους  συνθέσεις τζαζ  με επιρροές από την ελληνική παραδοσιακή μουσική και το ρεμπέτικο.Το 2006 παίρνει μέρος στην καλλιτεχνική επιμέλεια νέας επεξεργασίας του κύκλου τραγουδιών του Μίκη Θεοδωράκη «Τα Λυρικά» και περιοδεύει στην Γερμανία, το Λουξεμβούργο και την Ελλάδα.To 2007 ολοκληρώνει τις σπουδές της, αριστεύοντας στις διπλωματικές εξετάσεις και επιστρέφει στην Αθήνα όπου συνεργάζεται με τους Σάμι Αμίρι, Γιάννη Στραυρόπουλο, Λευτέρη Χριστοφή, Παντελή Μπενετάτο, Ανδρέα Γεωργίου και άλλους. Συμμετέχει επίσης σε διάφορα μουσικά σύνολα, ενώ παράλληλα ασχολείται με την διδασκαλία φωνητικής και αυτοσχεδιασμού.', 38.244492, 21.735212, 'Πατρέως 80'),
(1415451255419125, 'ο χορός του νότου', '2015-02-18 00:00:00', 'https://fbcdn-photos-c-a.akamaihd.net/hphotos-ak-xap1/v/t1.0-0/c0.7.50.50/p50x50/10981868_10152527281802396_5364266126829933775_n.jpg?oh=de4384d84d40d9f9f708637e133029e9&oe=569BA1D6&__gda__=1449023007_4a8241fc8c69307f5271261a31e3cb22', '', 'θέμα :  " ζευγάρια "                                                                                                                                                                                                                                                                                                                                     τετάρτη 18/2                                                                  είσοδος ελεύθερη', 38.244492, 21.735212, 'Πατρέως 80'),
(1557999794416378, 'Music soup Live Jazz', '2014-12-01 21:00:00', 'https://scontent.xx.fbcdn.net/hphotos-xfp1/v/t1.0-0/c0.7.50.50/p50x50/1656223_10152364241307396_7660195008063253341_n.jpg?oh=093cdb386d33e989944c79054ec66fac&oe=565DBF4D', '', 'Διασκευές, πρωτότυπες ενορχηστρώσεις και συνθέσεις που κινούνται από την ατμοσφαιρική διάθεση στη straight ahead jazz και από εκεί σε πιο funky grooves, και bluesy moods ανακατεμένα σε μία "μουσική σούπα".\n\n***\n«Ενα σχήμα που δεν σταματά να εκπλήσσει, ξεκίνησε με ενορχηστρώσεις και ρεπερτόριο-φόρο τιμής στον Nat King Cole, για να εξελιχθεί σε ένα Μπενσονικού τύπου jazz-funk όχημα, χωρίς να χάσει ίχνος από την κομψότητά του.[...] Δαιμόνιος τζαζμαν, ο κιθαρίστας Νέστορας Δημόπουλος, με βαθιά γνώση και απόλυτα cool στάση στο παίξιμό του, έχοντας περάσει μια δεκαετία στη Βοστόνη και στη Νεα Υόρκη, βρήκε το καλλιτεχνικό του έτερον ήμισυ στο πρόσωπο της Ευγενίας Καρλαύτη, η οποία στο πλευρό του άνθισε από κλασική πιανίστρια (μια από τις καλύτερες που διαθέτουμε) σε θυελλώδη τζαζ ερμηνεύτρια και τραγουδίστρια με ιδιαίτερη χροιά - ένα από τα μεγαλύτερα ταλέντα που κυκλοφορούν ανάμεσά μας.»\nΝίκος Κ. Φωτάκης (Jazz & Τζαζ Ιουλίου-Αυγούστου 2012)\n\nhttps://www.facebook.com/Music.soup1\n\n***\nΕυγενία Καρλαύτη (organ/vox)\nΝέστορας Δημόπουλος (guitar)\nΓιάννης Φλώρος (drums)', 38.244492, 21.735212, 'Πατρέως 80'),
(1591533214417038, 'Το Κοπή Τη Πίτα Νο3!', '2015-01-31 18:00:00', 'https://fbcdn-profile-a.akamaihd.net/static-ak/rsrc.php/v2/yE/r/tKlGLd_GmXe.png', '', 'Με μουσική και δωράκια', 38.244331, 21.735699, 'Patreos 83');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE IF NOT EXISTS `users` (
  `username` varchar(255) COLLATE utf8_bin NOT NULL,
  `password` varchar(255) COLLATE utf8_bin NOT NULL,
  PRIMARY KEY (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`username`, `password`) VALUES
('anastasia', 'tavoulinou');

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
