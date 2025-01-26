class Dvm < Formula
  desc "Deno Version Manager"
  homepage "https://dvm.deno.dev"
  url "https://github.com/justjavac/dvm/archive/refs/tags/v1.9.1.tar.gz"
  sha256 "3b9bb668c6bdac67c201c7de823c9737d302687a8bae98cab881b24c59207a4e"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6cdb2115b0981351d4b2802db8faaf11a9b35893bf0ee4b120111f3a18371451"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "33fa2434254ed908128c27ba48e8d442a653a83cc7d38f0c8a64abf3040e4983"
    sha256 cellar: :any_skip_relocation, ventura:       "01f9342be4adad5c8581b0a0c4518d9c5826f03cf4953a318a5e1e4dd5a72d5b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d30ee3a2762bff331e3ac96fefcf9137efc4e2a6e4381aa0477243e62cde7e27"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  # version patch, upstream pr ref, https://github.com/justjavac/dvm/pull/214
  patch do
    url "https://github.com/justjavac/dvm/commit/1c9b1f4e5106f4907dfeafe80cbf6be709ae01a2.patch?full_index=1"
    sha256 "b2c69414c91e9ad9b42fe507434b2b75c0a4b20ee28364bb82151316b9841cfd"
  end

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"dvm", "completions")
  end

  test do
    ENV["HOME"] = testpath

    assert_match <<~EOS, shell_output("#{bin}/dvm info")
      dvm #{version}
      deno -
      dvm root #{testpath}/.dvm
    EOS

    assert_match version.to_s, shell_output("#{bin}/dvm --version")
  end
end
