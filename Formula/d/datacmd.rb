class Datacmd < Formula
  desc "Auto-generative dashboards from different sources in your CMD"
  homepage "https://github.com/VincenzoManto/Datacmd"
  url "https://github.com/VincenzoManto/Datacmd/archive/refs/tags/v0.0.3.1.tar.gz"
  sha256 "15a1ffd74f667960b556f5b601991204b068217a71e2e350133dbb1c0f6a1f05"
  license "MIT"
  head "https://github.com/VincenzoManto/Datacmd.git", branch: "main"

  depends_on "go" => :build

  def install
    system "go", "mod", "tidy" # as it is missing `go.sum` file
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match "Error loading config or data", shell_output("#{bin}/datacmd -config does-not-exist.yml 2>&1", 1)
  end
end
