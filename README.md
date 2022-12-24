# Bids

This is a small microservice, resposible for handling bid amounts for our Pay Per Click bids platform. Other applications use this service to know what is the bid amount for a combination of country, category, and channel.

## Definitions

- **Bid**: The amount a vendor bids to pay for a click in a given country, category, and channel.
- **Country**: ISO 3166-1 alpha-2 country code. This microservice does not care about country names or any information other than the code.
- **Category**: A string code for a given category in our websites, for example: crm, finance, sports, hr...
- **Channel**: The string code for one of our websites. Capterra: ca, GetApp: ga, Software Advice: sa

## Business logic

Bids are organized into defaults and overrides.  Bidders are allowed to enter in bids that target a specific country, category, and channel, or, they can provide defaults at either the country, or, country/category level.

Given a sample bids table containing the following data:

| country       | category      | channel | amount |
| ------------- | ------------- | ------- | ------:|
| us            | finance       | ca      | 4.0    |
| uk            | sports        | *       | 3.0    |
| us            | *             | *       | 2.0    |
| *             | *             | *       | 1.0    |

this means that:
- The bid amount for the `us,finance,ca` combination is `$4.00`
- The bid amount for `uk,sports` in any channel would be `$3.00`
- Any combination in the `us` other than `us,finance,ca` would have `$2.00` bid amount
- And any other combination would have `$1.00` as bid amount

## Code challenge

The challenge is to create a `/bids` API endpoint that would allow other applications to request the bid amounts for different country, category and channel combinations. The endpoint should accept comma-separated lists of countries, categories and channels as parameters, and return a JSON object containing the array with all the combinations and the amount for each.

Sample request:

```
GET /bids?countries=us,uk&categories=finance,sports&channels=ca,ga
```

And the expected response is:
```
{
  "bids": [
    { 'country': 'us', 'category': 'finance', 'channel': 'ca', 'amount': 4.0 },
    { 'country': 'us', 'category': 'finance', 'channel': 'ga', 'amount': 2.0 },
    { 'country': 'us', 'category': 'sports', 'channel': 'ca', 'amount': 2.0 },
    { 'country': 'us', 'category': 'sports', 'channel': 'ga', 'amount': 2.0 },
    { 'country': 'uk', 'category': 'finance', 'channel': 'ca', 'amount': 1.0 },
    { 'country': 'uk', 'category': 'finance', 'channel': 'ga', 'amount': 1.0 },
    { 'country': 'uk', 'category': 'sports', 'channel': 'ca', 'amount': 3.0 },
    { 'country': 'uk', 'category': 'sports', 'channel': 'ga', 'amount': 3.0 }
  ]
}
```

For data storage, the code already provides a model mapped to a relational database table, but feel free to explore other solutions.

## Docker

The app can be run either locally or using Docker. If Ruby 3.1 is not installed in the local system, Docker can be used for convenience. The repository contains a `docker-compose.yml` file. Examples:

#### How to run the test suite

```bash
$  docker-compose run app bundle exec rspec
```

#### How to run Rails console

```bash
$  docker-compose run app bundle exec rails console
```

### Submitting Code
Please create a pull request in this repository with:

- A well written and performant solution, implemented in Ruby.
- The tests must pass
- Add as many tests as you think you need
- Good PR description containing your solution explanation as well as any pertinent information
- You can use whatever libraries you would like, as long as they can all be installed using bundle install. Please explain and justify your library choices in the PR description

### Grading criteria

- Correctness: solutions must produce correct result sets given any valid input
- Readability & Organization: code should be well organized and readable with well thought out architecture and naming choices
- Well-organized git history is a plus
