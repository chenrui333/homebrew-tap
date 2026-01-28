class UnusedDeps < Formula
  desc "Determine any unused dependencies in java_library rules"
  homepage "https://github.com/bazelbuild/buildtools"
  url "https://github.com/bazelbuild/buildtools/archive/refs/tags/v8.5.1.tar.gz"
  sha256 "e6de6eb19a368efe1f56549c6afe9f25dbcee818161865ee703081307581ef4b"
  license "Apache-2.0"
  head "https://github.com/bazelbuild/buildtools.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d207ab9aec542d9600932a2fa849b07d5a36b8fea6fe2f8b35a7d022dffa5348"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d207ab9aec542d9600932a2fa849b07d5a36b8fea6fe2f8b35a7d022dffa5348"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d207ab9aec542d9600932a2fa849b07d5a36b8fea6fe2f8b35a7d022dffa5348"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "963a8f1462bce3a73bd946ea7bdeb2c5566dc1188f4fd9d0eb8786419c2f1154"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fccbedd8456a72f1e42ba3a3b79393c358e2ef6cd53499a3c22a86e385dd6d41"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"unused_deps"), "./unused_deps"
  end

  test do
    system bin/"unused_deps", "--version"
  end
end
