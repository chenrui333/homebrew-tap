class CmakeInit < Formula
  include Language::Python::Virtualenv

  desc "Opinionated CMake project initializer"
  homepage "https://github.com/friendlyanon/cmake-init"
  url "https://github.com/friendlyanon/cmake-init/archive/refs/tags/v0.41.1.tar.gz"
  sha256 "fa6ab1e39c2f20ccd5dc5e254d66059b9123a92c5af984bebc9950cec6715fad"
  license "GPL-3.0-or-later"
  head "https://github.com/friendlyanon/cmake-init.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8771da8c5a5be962c95d62453b28e26ea1d44ffe4f467dab18689e0b703d3e47"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8771da8c5a5be962c95d62453b28e26ea1d44ffe4f467dab18689e0b703d3e47"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8771da8c5a5be962c95d62453b28e26ea1d44ffe4f467dab18689e0b703d3e47"
    sha256 cellar: :any_skip_relocation, sequoia:       "8771da8c5a5be962c95d62453b28e26ea1d44ffe4f467dab18689e0b703d3e47"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0bdf2b7876f51f2e377a8453e17dbefd83398f3f1eae02a6b28720437a06e2da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "34aea663849137c64d219c6059247e9bfd45030a1f9891e6918a9048f0a11903"
  end

  depends_on "python@3.14"

  def install
    buildpath.install "package/setup.py"
    inreplace "setup.py", "../", ""

    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cmake-init --version")

    system bin/"cmake-init", "--std=20", "-p=conan", "test-project"

    some_expected_files = %w[CMakeLists.txt conanfile.py source/main.cpp docs/ test/]
    some_expected_files.each { |f| assert_path_exists "test-project/#{f}" }
  end
end
