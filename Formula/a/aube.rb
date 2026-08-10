class Aube < Formula
  desc "Fast Node.js package manager"
  homepage "https://github.com/endevco/aube"
  url "https://github.com/endevco/aube/archive/refs/tags/v1.38.1.tar.gz"
  sha256 "1f8f1e93d7fe65bf25dee7c1827819db98723392aa0186cb308e7a087f27ea66"
  license "MIT"
  head "https://github.com/endevco/aube.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5ddf92202f861b85b2b8289f31683a4196274ea20ad08016dc1bab547a1d066f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4c7e2efd67ad5d77299f072ecb58f39ffe2e240b12fded28cebb2a6067a80dda"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "44545494ae506341e5bae60da7373c75eff044f6688f5b01a1fee5705eaadb77"
    sha256 cellar: :any,                 arm64_linux:   "2f7e747ef24b9ee7d99a9ed5fbdb45ddf618d4b3cfe13d5681265e3db739e2a9"
    sha256 cellar: :any,                 x86_64_linux:  "04ebbea285fc8905c68aac12e831fbb74e85ca264ffe58388d36031d99737ce3"
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
