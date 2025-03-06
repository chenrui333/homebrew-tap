class Goodls < Formula
  desc "CLI tool to download shared files and folders from Google Drive"
  homepage "https://github.com/tanaikech/goodls"
  url "https://github.com/tanaikech/goodls/archive/refs/tags/v2.0.5.tar.gz"
  sha256 "c9f4edd53c0296dfca4500e9e0ab9ae8fcd9e231693bafdd07dac8a121949036"
  license "MIT"
  head "https://github.com/tanaikech/goodls.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c2d2b37461601ffd925c00841abbace3b283343c693e648554518ccd986b6cee"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dc8d0e25e45b120d9ca7657897e252626d02951de4e794ce62adae0f37b8b596"
    sha256 cellar: :any_skip_relocation, ventura:       "c55a86ccba3a00da6438cd4233c4398115882355dd5d9e854e2b3b790c31d7d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "534a370c7a72e7b9c5d5423c4893340e78843a98724ea471407c926920218ed5"
  end

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
