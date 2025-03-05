class Goodls < Formula
  desc "CLI tool to download shared files and folders from Google Drive"
  homepage "https://github.com/tanaikech/goodls"
  url "https://github.com/tanaikech/goodls/archive/refs/tags/v2.0.5.tar.gz"
  sha256 "c9f4edd53c0296dfca4500e9e0ab9ae8fcd9e231693bafdd07dac8a121949036"
  license "MIT"
  head "https://github.com/tanaikech/goodls.git", branch: "master"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/goodls --version")

    expected = if OS.mac?
      "URL is wrong"
    else
      "no URL data"
    end
    assert_match expected, shell_output("#{bin}/goodls -u https://drive.google.com/file/d/1dummyURL 2>&1", 1)
  end
end
