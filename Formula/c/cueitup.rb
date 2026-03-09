class Cueitup < Formula
  desc "Inspect messages in an AWS SQS queue in a simple and deliberate manner"
  homepage "https://github.com/dhth/cueitup"
  url "https://github.com/dhth/cueitup/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "0aa289a5256986d05db30e45d1dca5f110f2169ff980a84303f894b5fd6025ee"
  license "MIT"
  head "https://github.com/dhth/cueitup.git", branch: "main"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(output: bin/"cueitup", ldflags: "-s -w"), "."
  end

  test do
    (testpath/"config.yml").write <<~YAML
      profiles:
        - name: profile-a
          queue_url: https://sqs.eu-central-1.amazonaws.com/000000000000/queue-a
          aws_config_source: env
          format: json
          subset_key: Message
          context_key: aggregateId
    YAML

    assert_match "config looks good", shell_output("#{bin}/cueitup config validate -c #{testpath}/config.yml")
  end
end
