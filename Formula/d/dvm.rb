class Dvm < Formula
  desc "Deno Version Manager"
  homepage "https://dvm.deno.dev"
  url "https://github.com/justjavac/dvm/archive/refs/tags/v1.9.3.tar.gz"
  sha256 "ce52f153d7d11f9cec3904b2a22b7298576a76be2f93fb026f8b780e5770d2df"
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
