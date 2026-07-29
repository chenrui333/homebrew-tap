class Aube < Formula
  desc "Fast Node.js package manager"
  homepage "https://github.com/endevco/aube"
  url "https://github.com/endevco/aube/archive/refs/tags/v1.36.0.tar.gz"
  sha256 "7e11c554fccc1f3d82fbb3a560206d51b058e8f5c8fc31b8f14eed3750f8e80d"
  license "MIT"
  head "https://github.com/endevco/aube.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "58cf9197424b56b0c06fa3144f5eaf85f4ee367a43859465aad21ca83fb7b981"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "da312d81f713d6ecd1229b83614e31c04d1e2a2ea91f508b9126d54b67c8e2ea"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "833f5d64b21fadac7b41fb941292121d6061ecb816ed3ac81522c58fff33589f"
    sha256 cellar: :any,                 arm64_linux:   "5ba33028e0d80ae018d88bf5d0dbbaa70477727896dfdf4fc565080cc41836e3"
    sha256 cellar: :any,                 x86_64_linux:  "b2acbda29fcfe064841ca6b813c6e601ac74fbde920cbbc7270f0236c974a401"
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
