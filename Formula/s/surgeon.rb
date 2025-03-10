# framework: cobra
class Surgeon < Formula
  desc "Surgically modify a fork"
  homepage "https://github.com/bketelsen/surgeon"
  url "https://github.com/bketelsen/surgeon/archive/refs/tags/v0.2.1.tar.gz"
  sha256 "4d4d81e82d5dc3373603c422e7209ec37821a5c00846b3d86526fe88a2d7ad6d"
  license "MIT"
  head "https://github.com/bketelsen/surgeon.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2ad80dc16655b2e1674e27a32cfd3244fcbf81e97da05a59d2baf9959eac6887"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "62e743ecc3187b72b665791a17c4066bc73aa3dbf21fb8c522e14a4d04009ea6"
    sha256 cellar: :any_skip_relocation, ventura:       "b75a58ea475835040ba4e9e2dd87f55547893fdfd078094fea6a011631350d55"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "344bf8c820d763f2cd4b12b43376df764ee4b78f78d85ee4abbe7fc46eb34569"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"surgeon", "completion")
  end

  test do
    system bin/"surgeon", "init"
    assert_match "description: Modify URLS", (testpath/".surgeon.yaml").read
  end
end
