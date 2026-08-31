class Aube < Formula
  desc "Fast Node.js package manager"
  homepage "https://github.com/endevco/aube"
  url "https://github.com/endevco/aube/archive/refs/tags/v2.2.4.tar.gz"
  sha256 "4e745ac1d2a51a869ca3f7761cd7892c6a5cad6c401e7c142bfbcac549a9092d"
  license "MIT"
  head "https://github.com/endevco/aube.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "942a97d66bfed99b2cead9258f778670f3d60c585276aeae0b036c0e2636bb72"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e2a801233f1ac26a4ab8f996c171c6754f5c87762e5da173439896f4b69d56dd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9f3c79d6accb3fa38d6f4f0bce6bf88624160dde60a6b672ff19a4a028ab5a7d"
    sha256 cellar: :any,                 arm64_linux:   "abe42bc294f2a5860015543bca0f8435695a39678e2f5b5126f70ba9c50635a2"
    sha256 cellar: :any,                 x86_64_linux:  "ee538b933f11218ef77deb323e6dd8dd5224cae6de5b89c9022a538576ea23e3"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build
  depends_on "usage" => :build

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
