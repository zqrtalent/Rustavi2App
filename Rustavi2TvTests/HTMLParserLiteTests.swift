//
//  HTMLParserLiteTests.swift
//  Rustavi2TvTests
//
//  Created by Zaqro Butskrikidze on 10/18/18.
//  Copyright © 2018 Zakaria Butskhrikidze. All rights reserved.
//

import Foundation
import XCTest
@testable import Rustavi2TvShared

class HTMLParserLiteTests : XCTestCase {
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        

        // <div class="all_news_block"><a href="/ka/news/116169" class="news_item"></a></div>
        //
        /*
         <a href="/ka/news/116169" class="news_item">
         <div class="img_box">
         <div class="news_photo" style="background-image:url(/news_photos/116169_cover.jpg)"></div>
         </div>
         <div class="news_info">
         <span class="red rioni date">22:57</span>
         <div class="grey nino ">ვიქტორ ჯაფარიძე არის ხელისუფლების მესენჯერი - ელისო კილაძე <img src="/img/video.gif"> </div>
         </div>
         <div style="clear:both"></div>
         </a>
         */

        let html =
"""
<a href="/ka/news/116169" class="news_item">
     <div1 class="img_box">
     <div11 class="news_photo" style="background-image:url(/news_photos/116169_cover.jpg)"   ></div11>
     </div1>
     <div2 class="news_info">
     <span21 class="red rioni date"  >22:57<  /span21>
     <div22 class="grey nino "    >ვიქტორ ჯაფარიძე არის ხელისუფლების მესენჯერი - ელისო კილაძე <img src="/img/video.gif"> </div22>
     </div2>
     <div3 style="clear:both"></div3>
     </a>
"""
        let elem = HTMLParserLite.parse(html: html, startIdx: html.startIndex)
        XCTAssert(elem != nil)
        XCTAssert(elem?.name == "a")
        XCTAssert(elem?.attributes.count == 2)
        XCTAssert(elem?.children?.count == 3)

        let titleDiv = elem?.lookupChildElement("div2[1]>div22[1]")
        XCTAssert(titleDiv != nil && titleDiv?.name == "div22")
        XCTAssert((titleDiv?.innerHTML(originalHtml: html) ?? "") == "ვიქტორ ჯაფარიძე არის ხელისუფლების მესენჯერი - ელისო კილაძე <img src=\"/img/video.gif\"> ")

        let spanElem = elem?.lookupChildElement("div2[1]>span21")
        XCTAssert(spanElem != nil && spanElem?.name == "span21")
        XCTAssert((spanElem?.innerHTML(originalHtml: html) ?? "") == "22:57")
    }
    
    func testParsingNewsDetail(){
        
        // Problematic to parse
        /*
         <span itemprop="articleBody"><p><span class="nanospell-typo-disabled" data-cke-bogus="true">უინძორის</span> სასახლეში მეგან <span class="nanospell-typo-disabled" data-cke-bogus="true">მარკლისა</span> და პრინც ჰარის საქორწინო კოსტიუმები გამოფინეს. ახალი ექსპოზიცია, სწორედ ამერიკელი მსახიობისა და პრინც ჰარის შეუღლებას ეძღვნება. &nbsp;</p>
         <p>19 მაისს გამართული ცერემონიის დროს, მეგან <span class="nanospell-typo-disabled" data-cke-bogus="true">მარკლს&nbsp;</span>&nbsp;ფრანგული მოდის სახლის,&nbsp; ჟივანშის მიერ შექმნილი კაბა ეცვა. პატარძალს 5 მეტრის სიგრძის, ხელით მოქარგული ფატა და დედოფალ, ელისაბედ მეორის ბრილიანტის <span class="nanospell-typo-disabled" data-cke-bogus="true">დიადემაც</span> ამშვენებდა. დარბაზში,&nbsp; წყვილის <span class="nanospell-typo-disabled" data-cke-bogus="true">ხელისმომკიდეების</span>, პრინცესა <span class="nanospell-typo-disabled" data-cke-bogus="true">შარლოტისა</span> და პრინცი ჯორჯის <span class="nanospell-typo-disabled" data-cke-bogus="true">კოსტიუმებიცაა</span> გამოფენილი.</p>
         <p>დამთვალიერებელს სამეფო ქორწილის მზადების შესახებ,&nbsp;პრინცი <span class="nanospell-typo-disabled" data-cke-bogus="true">ჰარისა</span> და მეგან <span class="nanospell-typo-disabled" data-cke-bogus="true">მარკლის</span> საუბრის აუდიო ჩანაწერის მოსმენაც შეეძლება. ექსპოზიცია <span class="nanospell-typo-disabled" data-cke-bogus="true">უინძორის</span> სასახლეში იანვრამდე გაგრძელდება.<br>&nbsp;</p></span>
         */
        
        let html =
        """
<span itemprop="articleBody"><p>8 წლის მოზარდის დედა მეზობელს მისი შვილის მიმართ განხორციელებულ ფიზიკურ ძალადობაში ადანაშაულებს.</p>
     <p>არასრულწლოვნის დედა ამტკიცებს, რომ 54 წლის მამაკაცი მის შვილს ფიზიკურად საცხოვრებელი კორპუსის ეზოში გაუსწორდა. ძალადობის სცენა კი თავისივე მობილური ტელეფონით გადაიღო. ქალი მომხდარის გამოძიებას და მამაკაცის დასჯას ითხოვს.</p>
     <p>დაზარალებული მოზარდის დედა ვარაუდობს, რომ ძალადობის შემდეგ მამაკაცი ბავშვის გატაცებასაც აპირებდა. მისი მტკიცებით, მამაკაცი მოზარდს საკუთარი ავტომობილში ჩაჯდომას ძალის გამოყენებით აიძულებდა.</p>
     <p>მოზარდის დედა აცხადებს, რომ ბავშვის წაყვანა მამაკაცმა ვერ შეძლო, რადგან ადგილობრივებმა მას ამის საშუალება არ მისცეს.</p>
     <p>ინციდენტის შემდეგ ადგილზე საპატრულო პოლიცია გამოიძახეს. საგამოძიებო მოქმედებების შედეგად სავარაუდო მოძალადის იდენტიფიცირება პოლიციამ შეძლო. თუმცა 54 წლის მამაკაცი პოლიციის განყოფილებაში გამოკითხვის შემდეგ გაათავისუფლეს. სავარაუდო მოძალადე ბრალდებებს უარყოფს, თუმცა ინციდენტის დეტალებზე ვრცლად საუბარი არ სურს.</p>
     <p>მოზარდზე ძალადობის ფაქტს კატეგორიულად გამორიცხავს სავარაუდო მოძალადის დედაც, რომელიც მოზარდის ოჯახს სიცრუეში ადანაშაულებს.</p>
     <p>მომხდარზე გამოძიება ძალადობის მუხლით მიმდინარეობს. მოზარდის დაზიანებების ხარისხს სავარაუდოდ ექსპერტიზა დაადგენს და ამის შემდეგ გაირკვევა, მოხდა თუ არა ძალადობა 8 წლის ბიჭზე.</p></span>
"""
        
        let elem = HTMLParserLite.parse(html: html, startIdx: html.startIndex)
        XCTAssert(elem != nil)
        XCTAssert(elem?.name == "span")
        XCTAssert(elem?.children?.count == 7)
    }
    
    func testLookupByClass(){
        let html =
        """
<div class="nw_cont">
<div class="spacer"></div><div class="date_l en">22-12-2018</div>

<div class="nw_line">
<div><span class="dt">15:30</span> <a href="/ka/news/121851" class="link">ზვიად გამსახურდიას საქმის გამოძიების ხანდაზმულობა 5 წლით გაგრძელდება  <img src="/img/video.gif"></a></div>
</div>

<div class="nw_line">
<div><span class="dt">15:18</span> <a href="/ka/news/121848" class="link">„მინიმუმ შეცდომა და მაქსიმუმ ტრაგედია" - „ქალთა მოძრაობა" პრეზიდენტის საპარლამენტო მდივნად დიმიტრი გაბუნიას დანიშვნას აქციიით აპროტესტებს  <img src="/img/video.gif"></a></div>
</div>

<div class="spacer"></div><div class="date_l en">22-12-2018</div>

<div class="nw_line">
<div><span class="dt">15:30</span> <a href="/ka/news/121851" class="link">ზვიად გამსახურდიას საქმის გამოძიების ხანდაზმულობა 5 წლით გაგრძელდება  <img src="/img/video.gif"></a></div>
</div>

<div class="nw_line">
<div><span class="dt">15:18</span> <a href="/ka/news/121848" class="link">„მინიმუმ შეცდომა და მაქსიმუმ ტრაგედია" - „ქალთა მოძრაობა" პრეზიდენტის საპარლამენტო მდივნად დიმიტრი გაბუნიას დანიშვნას აქციიით აპროტესტებს  <img src="/img/video.gif"></a></div>
</div>

</div>
"""
        
        let elem = HTMLParserLite.parse(html: html, startIdx: html.startIndex)
        XCTAssert(elem != nil)
        XCTAssert(HTMLElem.containsClass(elem: elem!, className: "nw_cont"))
        
        let nwLineElems = elem!.lookupChildElementsByClass("nw_line")
        XCTAssert(nwLineElems?.count ?? 0 == 4)
        
        XCTAssert(
            nwLineElems?.enumerated().allSatisfy({ (arg) -> Bool in
                return HTMLElem.containsClass(elem: arg.element, className: "nw_line")
            }) ?? false
        )
        
        let spacerElems = elem!.lookupChildElementsByClass("spacer")
        XCTAssert(spacerElems?.count ?? 0 == 2)
        
        XCTAssert(
            spacerElems?.enumerated().allSatisfy({ (arg) -> Bool in
                return HTMLElem.containsClass(elem: arg.element, className: "spacer")
            }) ?? false
        )
    }
}
