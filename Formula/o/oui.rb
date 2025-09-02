class Oui < Formula
  desc "MAC Address CLI Toolkit"
  homepage "https://oui.is/"
  url "https://github.com/thatmattlove/oui/archive/refs/tags/v0.1.8.tar.gz"
  sha256 "b3cb775c8ea6bf48b3b2bebcae7bb6c072620f11cdcf1b1092bae8fa15989e82"
  license "BSD-3-Clause-Clear"
  head "https://github.com/thatmattlove/oui.git", branch: "main"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/oui --version")
    output = shell_output("#{bin}/oui convert F4:BD:9E:01:23:45")
    assert_match "{244,189,158,1,35,69}", output
  end
end
