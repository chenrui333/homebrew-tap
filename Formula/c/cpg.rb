class Cpg < Formula
  desc "Cilium Policy Generator using Hubble relay"
  homepage "https://github.com/SoulKyu/cpg"
  url "https://github.com/SoulKyu/cpg/archive/refs/tags/v1.12.2.tar.gz"
  sha256 "070ffe95689a262c7477af5918d87e4d2243ff56665f27fe6a9a5bf595ad655d"
  license "Apache-2.0"
  head "https://github.com/SoulKyu/cpg.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2fbc2907e3aaf19ee7377b518ce7c9737c8f858e43f5f7bc24e2ef2fbfce4c6d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4af30daad00c860878e9cccafcb667f16edbf3cd6b7f49601644b616b8e09146"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0634845111fa742f3e0a0369c8f6f6857b048652355332d7b7c3177aadf44a2c"
    sha256 cellar: :any,                 x86_64_linux:  "d987afc562cad698077e8a0a2f1827468cfc57652ebb32b4fe3e18be76f08b6a"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "./cmd/cpg"

    generate_completions_from_executable(bin/"cpg", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cpg --version")
  end
end
