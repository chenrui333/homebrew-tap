class Cpx < Formula
  desc "Batteries-included Cargo-like CLI for C++"
  homepage "https://cpx-dev.vercel.app/"
  url "https://github.com/ozacod/cpx/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "0e83234edef4b87bcb1d33174a58e8a01b882760b869d0f9712a33ede6927059"
  license "MIT"
  head "https://github.com/ozacod/cpx.git", branch: "main"

  depends_on "go" => :build

  def install
    cd "cpx" do
      system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/cpx"
    end

    generate_completions_from_executable(bin/"cpx", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cpx --version")
    assert_match "vcpkg_root not set in config", shell_output("#{bin}/cpx list 2>&1", 1)
  end
end
