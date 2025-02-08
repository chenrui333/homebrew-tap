class CargoSort < Formula
  desc "Tool to check that your Cargo.toml dependencies are sorted alphabetically"
  homepage "https://github.com/devinr528/cargo-sort"
  url "https://github.com/DevinR528/cargo-sort/archive/refs/tags/v1.0.9.tar.gz"
  sha256 "c64588d04a53afb03fce1069a46f9a1b04588dc82f607ad50ba7950ca091770f"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ffa2c3f24f51e2cbbe9252d660d9381b15c2f102abf6b8681a5f9b3aef8d9f56"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5d56199c86b62148751469c35712a13e7b6bf4d5fcbe02e43bc18e2be9169d33"
    sha256 cellar: :any_skip_relocation, ventura:       "a34cccd68e8b3beb9388db7867696aadcad1dec5797d07c52a3a3f8c36d049d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "52da039473c9f9337d627198789c084c1c5b1f36f86393db14af603ba32709c5"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cargo-sort --version")

    mkdir "brewtest" do
      (testpath/"brewtest/Cargo.toml").write <<~TOML
        [package]
        name = "test"
        version = "0.1.0"
        edition = "2018"

        [dependencies]
        c = "0.7.0"
        a = "0.5.0"
        b = "0.6.0"
      TOML

      # system "#{bin}/cargo-sort", "--check"
      output = shell_output("#{bin}/cargo-sort --check 2>&1", 1)
      assert_match "Dependencies for brewtest are not sorted", output
    end
  end
end
