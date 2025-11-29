class Daylight < Formula
  desc "Track sunrise and sunset times in the terminal"
  homepage "https://github.com/jbreckmckye/daylight"
  url "https://github.com/jbreckmckye/daylight/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "369ce9dd5299a68febbae38278efdef9cc2a8e8a2d1934ac42e352dece2ff6e9"
  license "GPL-3.0-only"
  head "https://github.com/jbreckmckye/daylight.git", branch: "master"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")
  end

  test do
    ENV["NO_COLOR"] = "1"
    assert_match version.to_s, shell_output("#{bin}/daylight --version")
    assert_match "Ten day projection", shell_output(bin/"daylight")
  end
end
