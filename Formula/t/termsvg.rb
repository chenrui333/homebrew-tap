class Termsvg < Formula
  desc "Record, share and export your terminal as a animated SVG image"
  homepage "https://github.com/MrMarble/termsvg"
  url "https://github.com/MrMarble/termsvg/archive/refs/tags/v0.9.2.tar.gz"
  sha256 "b1245a32984aed094ea80962ee7ad771b4b0e862b24403c24a91fa3f81a19e56"
  license "GPL-3.0-only"
  head "https://github.com/MrMarble/termsvg.git", branch: "master"

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/termsvg"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/termsvg --version")

    output = shell_output("#{bin}/termsvg play nonexist 2>&1", 1)
    assert_match "no such file or directory", output
  end
end
