class Starcharts < Formula
  desc "Plot your repository stars over time"
  homepage "https://starchart.cc/"
  url "https://github.com/caarlos0/starcharts/archive/refs/tags/v1.10.0.tar.gz"
  sha256 "df9599decfb241557d18c4c03e9204c65182117f9f12fe5322b75420617d401c"
  license "MIT"
  head "https://github.com/caarlos0/starcharts.git", branch: "main"

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"

    system "go", "mod", "tidy"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    pid = spawn bin/"starcharts"

    sleep 2

    begin
      output = shell_output("curl -s http://localhost:3000")
      assert_match "meta name=\"description\" content=\"StarCharts\"", output.strip
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
