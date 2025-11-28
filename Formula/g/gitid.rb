class Gitid < Formula
  desc "Tool to stop sending work commits with your personal email"
  homepage "https://github.com/nathabonfim59/gitid"
  url "https://github.com/nathabonfim59/gitid/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "28e9760e884bafadcf31d898abd8dd0b03f0af3b0beb807ae16a7ab357a103ed"
  license "MIT"
  head "https://github.com/nathabonfim59/gitid.git", branch: "main"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")

    # generate_completions_from_executable(bin/"gitid", "completion")
  end

  test do
    assert_match "No identities configured", shell_output("#{bin}/gitid list")
    system bin/"gitid", "add", "BrewTest", "test@brew.sh", "homebrew"
    assert_match "BrewTest", shell_output("#{bin}/gitid nickname test@brew.sh homebrew")
  end
end
