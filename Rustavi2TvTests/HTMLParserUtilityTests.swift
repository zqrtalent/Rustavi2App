//
//  HTMLParserUtilityTests.swift
//  Rustavi2TvTests
//
//  Created by Zaqro Butskrikidze on 12/2/18.
//  Copyright © 2018 Zakaria Butskhrikidze. All rights reserved.
//

import XCTest
import Rustavi2TvShared

class HTMLParserUtilityTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testHTMLCommentsRemoval() {
        let html = """
<div class="vd">
        <div class="l">
            <div class="pl">
            
                                        <div class="ph" style="background-image:url(/shows_videos/38220.jpg)" id="plr">
                            <!--<a onClick="show_vplayer('#plr','38220')"></a>-->
                            <a href="/ka/video/38220?v=2" class="link"></a>
                        </div>
                    
                
                <div class="txt rioni">კურიერი - 15:00 2 დეკემბერი, 2018</div>
            </div>
        </div>
        <div class="r">
            <div class="r_hed black nino">&nbsp; გადაცემის შესახებ</div>
            <div class="r_txt rioni black"><p>“კურიერი” საქართველოში ყველაზე ოპერატიული და მაღალრეიტინგული საინფორმაციო პროგრამაა.</p>
<p>საინფორმაციო გამოშვება დღეში შვიდჯერ გადის “რუსთავი 2”-ის ეთერში. ქვეყანაში და მის ფარგლებს გარეთ მიმდინარე უმნიშვნელოვანეს მოვლენებს დღის განმავლობაში “კურიერის” ჟურნალისტებთან ერთად თამარ ბაღაშვილი, ქეთი კვაჭანტირაძე, ანუკა ქინქლაძე, ნათია გოგსაძე, ნინო გაზდელიანი ეკო მაღრაძე და მიხეილ სესიაშვილი აშუქებენ, საღამოს 9 საათზე კი მთავარ საინფორმაციო გამოშვებაში დღის ამბებს პაატა იაკობაშვილი და დიანა ჯოჯუა აჯამებენ.</p>
<p>თუ თქვენ ფლობთ მნიშვნელოვან ინფორმაციას და ფიქრობთ, რომ ეს ინფორმაცია საზოგადოებისთვის საინტერესოა, დაგვიკავშირდით შემდეგ ნომერზე 2201111 ან მოგვწერეთ მისამართზე: <span class="text_blue" data-mce-mark="1"><a class="link_red" href="mailto:courier@rustavi2.com"><span style="font-size: small;" data-mce-mark="1">courier@rustavi2.com</span></a>&nbsp;</span></p></div>
            <!--
            <div class="fb-like-box" data-href="https://www.facebook.com/rustavi2" data-width="287" data-height="340" data-colorscheme="light" data-show-faces="true" data-header="true" data-stream="false" data-show-border="true"></div>-->
        </div>
        <div style="clear:both"></div>
    </div>
""";
        let resultHTML = HTMLParserUtility.getRidOfTheHTMLComments(html)
        XCTAssert(!(resultHTML.range(of: "<!--")?.isEmpty ?? false))
        XCTAssert(!(resultHTML.range(of: "-->")?.isEmpty ?? false))
    }
    
    //"http://www.rustavi2.ge/ka/video/38951?v=2"
    
    func testExtractUrlLastParam(){
        XCTAssert(HTMLParserUtility.extractLastParamOfUrl(url: "http://www.rustavi2.ge/ka/video/38951?v=2") == "38951")
        XCTAssert(HTMLParserUtility.extractLastParamOfUrl(url: "http://www.rustavi2.ge/ka/video/389523") == "389523")
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
