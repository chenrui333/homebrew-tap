class CargoSort < Formula
  desc "Tool to check that your Cargo.toml dependencies are sorted alphabetically"
  homepage "https://github.com/devinr528/cargo-sort"
  url "https://github.com/DevinR528/cargo-sort/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "2add0719d3309e868e8e305ce33bfbbd59554853e1cef2866af6745b750a689a"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "86e60017617b5ffee2e959043038aa84a596e1a20b73545f155df5e811641b4d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "af3c4e1e68462ab584b968f07f41c26e4ffa895844c49a191634190f07fb1a53"
    sha256 cellar: :any_skip_relocation, ventura:       "19070bb8f48e29945567da784fd5618893d5fab607ee3820a2999e3252d77554"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "29047e5a6c0e6a34acf649c3309201ccc2921ae57459e3d9393785b047ae7a27"
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
