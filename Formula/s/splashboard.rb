class Splashboard < Formula
  desc "Customizable terminal splash screen with plugin-based data sources"
  homepage "https://github.com/unhappychoice/splashboard"
  url "https://github.com/unhappychoice/splashboard/archive/refs/tags/v2.2.0.tar.gz"
  sha256 "e8c8ea8fe7269b4580699c9d28c4c16d75b84f95c775868da468ef380ba34742"
  license "ISC"
  head "https://github.com/unhappychoice/splashboard.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "37b9d977a3132e9de3f6019cab5ba837e7d1463387f300828f1076355d82362e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "79318b64c1fef042ebeb5673690763eac1a09fe66ed51c92d375fdc0323d7444"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ec0246661e208a94cd670bf10897b7abcc1a0284867243356a7de0b9878686fa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "31bbfbec984e6e96fe77324f2d23aa4421f6b691e4375a327a789c898ab9fe0d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a700fbe641b5bfc200d2f1a28d02ada5e02318f6fb6599143f2ea0a8e4999091"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/splashboard --version 2>&1")
  end
end
