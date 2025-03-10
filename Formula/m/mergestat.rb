class Mergestat < Formula
  desc "Query git repositories with SQL"
  homepage "https://github.com/mergestat/mergestat-lite"
  url "https://github.com/mergestat/mergestat-lite/archive/refs/tags/v0.6.2.tar.gz"
  sha256 "de7c6f51c136d688d07f8ead79c499e90156ca3e87c4427f049c1cb105be942d"
  license "MIT"
  head "https://github.com/showwin/speedtest-go.git", branch: "master"

  depends_on "go" => :build

  resource "git2go" do
    url "https://github.com/libgit2/git2go.git",
        revision: "4b14d29c207e9969ea62a7fe07d490b036c14722"
  end

  def install
    buildpath.install resource("git2go")

    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "-mod=readonly"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/speedtest --version 2>&1")

    system bin/"speedtest"
  end
end
