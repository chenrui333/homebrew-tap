class Goodls < Formula
  desc "CLI tool to download shared files and folders from Google Drive"
  homepage "https://github.com/tanaikech/goodls"
  url "https://github.com/tanaikech/goodls/archive/refs/tags/v2.0.6.tar.gz"
  sha256 "1131c18b9677b8faa87140806f2f9548572a72f710ed3564a85f01085b801d98"
  license "MIT"
  head "https://github.com/tanaikech/goodls.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "13f9fa4100666361a7687e20ee7c5ceaa1bc89468473b117ffbdf83f4fcdc984"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2c30eec35c4b0e4d37251c53a842bad2986a866244404821ece4e38d1d991124"
    sha256 cellar: :any_skip_relocation, ventura:       "b3fe65d58c991aa3bb97657aec2e5889f351b8c9f74474e205beaf6241d5d57a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "daaa74e10eac2ba025fbc9c0b6cf4a9ea85deec29cd9f33250c7eafb21dcd04c"
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
