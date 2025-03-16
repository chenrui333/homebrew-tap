class Wedl < Formula
  desc "CLI to download from https://wetransfer.com"
  homepage "https://github.com/gnojus/wedl"
  url "https://github.com/gnojus/wedl/archive/refs/tags/v0.1.11.tar.gz"
  sha256 "1d52adf91a6a0424e54610741b48384135ee2e7c4c2bf13e8a9f6f4d301dd1dc"
  license "Unlicense"
  head "https://github.com/gnojus/wedl.git", branch: "master"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/wedl --version")
    system bin/"wedl", "https://we.tl/responsibility"
    assert_path_exists testpath/"WeTransfer_Responsible_Business_Report_2020.pdf"
  end
end
