class Ngtop < Formula
  desc "Nginx access logs analytics"
  homepage "https://github.com/facundoolano/ngtop"
  url "https://github.com/facundoolano/ngtop/archive/refs/tags/v0.4.6.tar.gz"
  sha256 "41fe7b63277c67f521155030e028b53ebc0649fb34919bc31785b0b3723b5c6f"
  license "GPL-3.0-only"
  head "https://github.com/facundoolano/ngtop.git", branch: "main"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ngtop --version")

    assert_match <<~EOS, shell_output("#{bin}/ngtop --limit 1")
      #REQS
      0
    EOS
  end
end
