class Aube < Formula
  desc "Fast Node.js package manager"
  homepage "https://github.com/endevco/aube"
  url "https://github.com/endevco/aube/archive/refs/tags/v2.2.6.tar.gz"
  sha256 "b51611ca269dba88d75056e97bfb9673e3c1c3ac822216aa56eeff49f299487d"
  license "MIT"
  head "https://github.com/endevco/aube.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8929feb1b53ed1c9e6a340d1ef4d9dbf9b1722a0e271551a57494e79f36627b8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1004e907dcc351bbf3e06357c4de95742191da16372d0345ddbd611576b1d24c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cbcd1bf2e0f3cb208ef9de132ada2af80fed4c7950f411d7c554c88d600ab387"
    sha256 cellar: :any,                 arm64_linux:   "92df9de5ffb27c3a8f34d9042c2cc4fc40ceedb81b77f5d89ba3253f6d06be34"
    sha256 cellar: :any,                 x86_64_linux:  "f39147db85bbcac12b17c9910d183f76dcfb144815aa029f2b823da4d2ae7428"
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
