require "spec_helper"
require "rack/test"
require_relative '../../app'

def reset_tables
  seed_sql = File.read('spec/seeds/seeds_chitter.sql')
  connection = PG.connect({ host: '127.0.0.1', dbname: 'chitter_test' })
  connection.exec(seed_sql)
end

describe Application do
  include Rack::Test::Methods
  let(:app) { Application.new }
  before(:each) { reset_tables }

  context "get '/' route " do
    it "returns 200 OK and a list of peeps" do
      response = get('/')
      expect(response.status).to eq 200
      expect(response.body).to include('My first peep')
    end
  end

  context "get '/new-peep route" do
    it "returns 200 OK and the form for a new peep" do
      response = get('/new-peep')
      expect(response.status).to eq 200
      expect(response.body).to include '<form action="/new-peep" method="POST">'
    end
  end

  context "post /new-peep route" do
    it "returns 200 OK and a success page" do
    response = post('/new-peep', content: 'This is my third post meow')
    expect(response.status).to eq 200
    expect(response.body).to include('<p>Your peep was successfully posted</p>')
    # Need to add user_id and created_date_time
    end
  end
 
  context "get /new-user route" do
    it "returns 200 OK and the register form for a new user" do
      response = get('/new-user')
      expect(response.status).to eq 200
      expect(response.body).to include('<legend>Register as a new user</legend>')
    end
  end
end