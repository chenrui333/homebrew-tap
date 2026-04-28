class Wedl < Formula
  desc "CLI to download from https://wetransfer.com"
  homepage "https://github.com/gnojus/wedl"
  url "https://github.com/gnojus/wedl/archive/refs/tags/v0.1.11.tar.gz"
  sha256 "1d52adf91a6a0424e54610741b48384135ee2e7c4c2bf13e8a9f6f4d301dd1dc"
  license "Unlicense"
  head "https://github.com/gnojus/wedl.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "73ab2463cce3c2bcd30ccf5443d5fc1d14a4279a606702a25bd88ecd14162f67"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "af1029478115f5cf6fd7f6559fd014dbc698849d35be4316151f59893010bb1b"
    sha256 cellar: :any_skip_relocation, ventura:       "ea7f04ace575e2694376b059dd6e8fe69790fca7c5c71e1dda83059f1c65e382"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d9f50dac139f66fa0edaf27b7d2cb100d8af1871b99b455378c6b70e2cf42610"
  end

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
