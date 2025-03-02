class Todoist < Formula
  desc "CLI for Todoist"
  homepage "https://github.com/sachaos/todoist"
  url "https://github.com/sachaos/todoist/archive/refs/tags/v0.22.0.tar.gz"
  sha256 "b8220ec1ec14f298afed0e32e4028067b8833553a6976f99d7ee35b7a75d5a71"
  license "MIT"
  head "https://github.com/sachaos/todoist.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "32b5113bcdb5387a66333644b1a69804b0a7459d5198860f7de484e85a806fc1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a92f3ad078d39d4d140ee52129b540038e1363269b9708f805fd03782d8429a3"
    sha256 cellar: :any_skip_relocation, ventura:       "f5eceed2a5cab601adc87d9085822ebe1e0be43e8a08ade5eee0b80620328009"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1c1c8dd8fc31abff0e7e321f33c16aed1527cd72f0a645920f2b14e3c655602e"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/todoist --version")

    test_config = testpath/".config/todoist/config.json"
    test_config.write <<~JSON
      {
        "token": "test_token"
      }
    JSON
    chmod 0600, test_config

    output = shell_output("#{bin}/todoist list 2>&1")
    assert_match "There is no task.", output
  end
end
