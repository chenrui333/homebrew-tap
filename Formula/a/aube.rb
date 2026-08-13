class Aube < Formula
  desc "Fast Node.js package manager"
  homepage "https://github.com/endevco/aube"
  url "https://github.com/endevco/aube/archive/refs/tags/v1.40.0.tar.gz"
  sha256 "a836796d9e72ac8af6ad31172572a2f7919cb2481cd318a65e5e3e1052b5c429"
  license "MIT"
  head "https://github.com/endevco/aube.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7b24b5d0f35f1c831d5eb0d7a10691634a0f2e3ee87b20b1159f7c74b731dfed"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fc6a0181ab15fc15ccdf684495d03744d6e9c8dd9f37c43e17a1eb9394e3e4c9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "83ad6f4fbc773493278f4814793151f4f029d425e3c333321f159cf162ea29ff"
    sha256 cellar: :any,                 arm64_linux:   "4efb165c4d71a536a00917a10e12acbc58926d16970ce52090ea7f741d108d54"
    sha256 cellar: :any,                 x86_64_linux:  "6713805cf407910bdaf511b28733831b1082661fb8fbc7925a66956debbb0cf5"
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
