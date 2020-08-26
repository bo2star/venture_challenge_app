*Considerations*
- AngularJS - since the new Foundation is going to be integrated with angular, it would be nice to consider this from the beginning - realtime charts and a snappier learning materials wizard.
- http://zurb.com/article/1312/the-next-foundation
- https://github.com/zurb/foundation-apps


*Resource Definitions:*

Instructor:
+ Professor, Teacher or competition administrator.
+ Has many competitions.

Student:
+ Individual user who belongs to a team
+ Can have one store to account for individuals rather than teams.
+ Has many Points

Team:
+ Has many Students.
+ Has one Shopify store.
+ Has many Points
+ Has a team Profile

Competition:
+ Belongs to an Instructor.
+ Has many Teams or Students.

Points:
+ Earned through Revenue, Customers and "mini-games"
+ Belong to Students or Teams

Games:
+ "Mini-games" that allow Teams to gain additional points.
+ Belong to Competition

Badges:
+ Badge are earned for completing tasks
+ Belong to Competition

Learning_Materials:
+ Belong to Competition

Gems and Libraries:
+ Roles: I've been using Pundit. Can provide some boilerplate code for this if needed.
+ Frontend: I'd like to use Foundation, Foundation for Apps with Angular integration is being released end of September.
+ Draper: Will be handy for leaderboards.
+ Charts: AMcharts
+ Devise
+ Stripe

##Basic User Stories
####Instructor:
I should be be able to create an account using my Linkedin Account or by registering.
*Required info:*
- Full Name
- School Name
- Email Address
- Phone Number

I should be able to create a Competition with the following parameters:
- Start Date
- End Date
- Class Name (ie UBC 198 Intro to Business Fall 2014)
- Intro message to Students
- Select required Learning Materials

I should be able to view the Competition Leaderboard and individual Team metrics views.

I should be able to view individual students and verify that they have completed the learning resources.

#####Verify Students?

I should be able to import a CSV list of student emails and email them invite codes to the competition.


*Stretch Features*
- I should receive a notification if a team has not successfully completed any mini-games or received points. Notification should prompt advice based on level of Revenue/ Customers acquired.
- Automatic Grading based on Team Score and completion of Learning Materials


####Student:
I should be be able to create an account using my Linkedin Account or by registering.
- Full Name
- School Name
- Email Address

I should be able to pay as part of the registration process with Stripe.

I should be entered into a competition based on invite code from instructor, either through a link in en email or a 5 digit PIN.

I should be able to see other students who have joined a competition and invite them to join a team or accept an invite to join a team.

I should be able to view a learning materials page that is "wizard" like in guiding me through building a store.

I should be able to mark each wizard step complete once I have completed the step. (Potentially have to answer a multiple choice question for verification)

####Team:
A Team should be able to authenticate a Shopify store using Shopify Oauth strategy.

A team should build a profile which outlines there business plan.
- Customer Segments
- Revenue Streams
- Cost Structures
- Marketing Channels
- Value Proposition
- ect.

A team should see key metrics for their store on their Team show page.
- Revenue over time
- Customers over time
- Orders over time
- Referral Sources
- Repeat Customers

A Team should receive points for Revenue, Customers and Mini-Games.


#### Competition:
- All users who belong to a competition individually or through a team should be able to see an overall leaderboard based on points.

- All users should see a graph of revenue over time for all Teams.

- All users should see a graph of customers over time for all Teams.

#### Mini-Games:
- 5 Customers acquired through referrals
- 1 Repeat Customer
- 5 Facebook Customers
- 5 Twitter Customers
- 5 Adwords Customers


#### Badges:

- Setup Facebook page
- Setup Abandonment Protector (Shopify)
- Get articly published
- Build Landing Page (Unbounce)
- Sell Something with Upsell app (Shopify)
- ect.



####Super Admin
CRUD for managing resources

##New Features
*How to build an ecommerce store wizard:*
- https://strategyzer.com/academy/course/business-models-that-work-and-value-propositions-that-sell/1/1

*best practices wiki:*
- Student driven learning resources

*Rating for learning resources:*
- Rate the resources below

*Links to outside resources:*
- http://www.abetterlemonadestand.com/
- Shopify Ecommerce University
- http://www.helpfulcanvas.com/

*LMS integration*
- Geoff can you give more insight into these? What the top ones are? How we might integrate?

*clarity.fm integration*
- All we need is a button that says ask an expert: We setup and affiliate program with Dan that is mutually beneificial. Easy Easy and allows us to advertise guaranteed access to some of the worlds top entrepreneurs.

*Charity marketplace*
- After Teams are formed they select a charity to donate to. This eventually will be monetized by taking a cut, but in the mean time we benefit from the credibility of partnering with high profile organizations.

Key point: We need to own the charity relationship, not the students, even if we are introduced to new charities by students.

*Choose your own adventure business idea:*
- http://whythefuckshouldichooseoberlin.com/

*Post OVC updates to Linkedin from student and Instructor accounts:*
- Potential to be seen a "real-life" experience that employers value

*Unbounce Partnership:*
- Talk to unbounce about a free trial for ovc students.. Unbuounce API

*Ask prof for support*


###TBD
- Instructor should they have multiple accounts?
- OK to authorize students with only Linkedin accounts?
