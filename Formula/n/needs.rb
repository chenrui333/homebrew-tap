class Needs < Formula
  desc "Checks if bin(s) are installed, oh and the version too"
  homepage "https://github.com/NQMVD/needs"
  url "https://github.com/NQMVD/needs/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "0b20957fd5cfd926ec9e20bb26316322dac73f1788d59d95256cc14f69b13d1c"
  license "GPL-3.0-or-later"
  head "https://github.com/NQMVD/needs.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "910a2bdf293156b018c5d8dc5ff961051296215a0a26deb271b9928becb46772"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ded303c7f7fa535b3d37e99d61dce86cae019498a779fff55bb9b2731487d741"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6036ced1c72bb87375d2ca88acc73a2513d84baf62fac23c48a3b450f4df8aa5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ec1ec6512aec303224f471bb6560d9ea338f9540b51346ab66cafbeac0100095"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b97d747350db17494c2847dd5aa200022cd094005ddd2db11aef851efae16155"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/needs --version")

    assert_match "curl", shell_output("#{bin}/needs curl")
    assert_match "go not found", shell_output("#{bin}/needs go")
  end
end
