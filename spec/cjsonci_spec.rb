RSpec.describe CJSONCI do
  it "has a version number" do
    expect(CJSONCI::VERSION).not_to be nil
  end

  it do
    input = {
      eval: "'hello'.reverse"
    }

    servant_k = Kommando.new "ruby e2e/servant.rb", output: true

    got_olleh = false
    servant_k.out.once "olleh" do
      got_olleh = true
    end

    servant_k.run_async
    servant_k.in.writeln input.to_json

    loop do
      break if got_olleh
      sleep 0.001
    end

    servant_k.kill
    expect(got_olleh).to be_truthy
  end

  it do
    client_k = Kommando.new "ruby e2e/client.rb", output: true
    client_k.run
    expect(client_k.out).to eq "2\r\n"
  end
end
