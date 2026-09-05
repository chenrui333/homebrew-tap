class Xled < Formula
  desc "Transform tabular data using regular expressions"
  homepage "https://github.com/excelano/xled"
  url "https://github.com/excelano/xled/archive/refs/tags/v0.12.2.tar.gz"
  sha256 "5ad0e96f48cc5b56afb2957698073c89af9a75438acdeac8ce6aa8e36e28779d"
  license "MIT"
  head "https://github.com/excelano/xled.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ef846077001f24cccf9154fe51ef37c54daacdd5cc429b244c35493d3cc5cd55"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "41ac52dbc93ceda743a1f878ede3fee8fcf3b3fc69f499d3a38d4a5c07af81ea"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "332f0c806b32fcae59bc38e50dadae17ec14d6ba23155d2afa432fab4daeee6d"
    sha256 cellar: :any,                 arm64_linux:   "6220e300fc5774d6fca3ee8f0b373b30583d5ed03dac23626ce89aca829da7e3"
    sha256 cellar: :any,                 x86_64_linux:  "f0d44f6427924c23382958b2e27557ed01936e99787f4d8d0bd1415bfb062cb7"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/xled --version")
    (testpath/"input.csv").write("name\nold\n")
    assert_equal "name\nnew\n", shell_output("#{bin}/xled '[name] s/old/new/' #{testpath}/input.csv")
  end
end
