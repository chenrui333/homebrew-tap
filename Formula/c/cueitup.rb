class Cueitup < Formula
  desc "Inspect messages in an AWS SQS queue in a simple and deliberate manner"
  homepage "https://github.com/dhth/cueitup"
  url "https://github.com/dhth/cueitup/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "0aa289a5256986d05db30e45d1dca5f110f2169ff980a84303f894b5fd6025ee"
  license "MIT"
  head "https://github.com/dhth/cueitup.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "07ff9028af8985437bc8d07c851b66c6102db44a623f088b0d276aaa36837f4b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "07ff9028af8985437bc8d07c851b66c6102db44a623f088b0d276aaa36837f4b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "07ff9028af8985437bc8d07c851b66c6102db44a623f088b0d276aaa36837f4b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "033fb6e50bd3af57d0ba8d85d483000b8dda8bc8e4b0dbdee47dca0b7cd63678"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9765495de94fec047cb16aa33931cf73b4717d16e16d46c11ba693f107a09c8a"
  end

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
