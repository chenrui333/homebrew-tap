class Aube < Formula
  desc "Fast Node.js package manager"
  homepage "https://github.com/endevco/aube"
  url "https://github.com/endevco/aube/archive/refs/tags/v2.8.4.tar.gz"
  sha256 "6dff091636482b516d2af46bdae989671f36a82304cd69b901236a12c2731d82"
  license "MIT"
  head "https://github.com/endevco/aube.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e07d84852eda62447a7b730829d9660ddca0b99629ee745c49c73a56371a448c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "953ef31348d06cd3bb17c5aa839df45d6bf42f37c364eeeb08c0c4d89dfdf605"
    sha256 cellar: :any,                 arm64_linux:   "c44417052cc3a1b311d6764e2f44a0165d6590d579b4cdddddf61d225f68d26d"
    sha256 cellar: :any,                 x86_64_linux:  "4d4bc0da3cada57387a1637829de8c80050c27cb44e82de2fcebd06f57ee9b7f"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build
  depends_on "usage" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/aube")

    generate_completions_from_executable(bin/"aube", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/aube --version")
    assert_path_exists bin/"aubr"
    assert_path_exists bin/"aubx"

    (testpath/"package.json").write('{"name":"test","version":"0.0.1"}')
    system bin/"aube", "install"
  end
end
