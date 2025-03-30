class Tuono < Formula
  desc "Superfast fullstack React framework"
  homepage "https://tuono.dev/"
  url "https://github.com/tuono-labs/tuono/archive/refs/tags/v0.19.1.tar.gz"
  sha256 "ab099a7ab424f3e1f383a3aebe8332b957ce08c785238fd488b162c16b2756df"
  license "MIT"
  head "https://github.com/tuono-labs/tuono.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b9acc8e47be7f0a726d901db5d60f9c870fdc366a07ec7ee44c9a9d9da21af43"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4dd047e3848fd3c4b6a75610f4c2b6bc0033d004024268a6ae2acf8d74f267de"
    sha256 cellar: :any_skip_relocation, ventura:       "e9393397c7a098c83a166ced18fc006902d6bd561e43c59975d67793e722c255"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d593fbaf68468c765890045c1639c3a3197d6af5b6953f527b683c45941a77ab"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/tuono")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tuono --version")

    system bin/"tuono", "new", "my-app"
    assert_path_exists testpath/"my-app/package.json"
  end
end
