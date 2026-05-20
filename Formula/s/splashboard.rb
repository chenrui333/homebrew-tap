class Splashboard < Formula
  desc "Customizable terminal splash screen with plugin-based data sources"
  homepage "https://github.com/unhappychoice/splashboard"
  url "https://github.com/unhappychoice/splashboard/archive/refs/tags/v2.6.0.tar.gz"
  sha256 "23e71af3635815860228ef8b2e65f9088578fff360e22ef8f1afd50a19443e0e"
  license "ISC"
  head "https://github.com/unhappychoice/splashboard.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f4957faa5515876531a6b683ec11b46ec894359537d0cafba0a52c4f07b2ad52"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0a19b4d0983bb6954222bc6728291eacaa55b8da44e56f25d5fcab34016a1f45"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c883efa6a1488f356ae25dc4b024face1de1d8447049541060537d125cf7b25e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "825b1b4547d9310313ad63dad8bdbbd50a2ca19badd9607938e3472550be7562"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "efec918d8b5084a4a6a566191f05cd6569bc191c5d310b338fc14fcc796e18e9"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/splashboard --version 2>&1")
  end
end
