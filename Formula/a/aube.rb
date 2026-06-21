class Aube < Formula
  desc "Fast Node.js package manager"
  homepage "https://github.com/endevco/aube"
  url "https://github.com/endevco/aube/archive/refs/tags/v1.23.0.tar.gz"
  sha256 "0bc3ee02d1f490cfd1f3667b7d1af739253886155fd6efd05db699ea789350da"
  license "MIT"
  head "https://github.com/endevco/aube.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "47d486841523d8cce234172d9383d863a6387014f3380e4ed675596d7f790495"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1547be96b9819cb4e03f6df8bdfb3378d0e3b41448f9ec42b8f35069714754e3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "07e942ab591fb6a5984b89b882bbea30b4f5d9dccc0d18ee41461b47f707547e"
    sha256 cellar: :any,                 arm64_linux:   "9b430758a37d06824275f4754db56edb6e074e46943b7bbf0f03c0b1b32ddc04"
    sha256 cellar: :any,                 x86_64_linux:  "e588c32153714044e296ae3a1fc647b147b71945bae066be7dfad49e20e4c5c5"
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
