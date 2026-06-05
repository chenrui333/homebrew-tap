class Tennis < Formula
  desc "Print stylish CSV tables in your terminal"
  homepage "https://github.com/gurgeous/tennis"
  url "https://github.com/gurgeous/tennis/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "d32f9b022ebff218e8f37880f73c2c0811c2e15d7022f21f306cf747dbb2889f"
  license "MIT"
  head "https://github.com/gurgeous/tennis.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7c1d320e8636edf4ba0d0964f614a0542f23a2132a7e39c1f7ece37428d02e67"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e421e2d50098cecf621896284588c72c37b8a2a779a975f0d60949ae90a160c8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "32dcde4d041654b7f46cff28d9c8c256c3a7124596b0cce7a869b0eb77fd90a9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d641df790169c871a81439cd1b7e1e7ce1198d3c934acd5489ea3c39cc438af5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "51c029dce4bc423aee93a58fff9091e6cf4210879f3b7f88230020cac2d4ee53"
  end

  depends_on "zig" => :build

  def install
    cpu = case Hardware.oldest_cpu
    when :arm_vortex_tempest then "apple_m1"
    when :armv8 then "generic"
    else Hardware.oldest_cpu
    end

    args = []
    args << "-Dcpu=#{cpu}" if build.bottle?

    system "zig", "build", *std_zig_args, *args

    bash_completion.install "extra/tennis.bash" => "tennis"
    zsh_completion.install "extra/_tennis"
    man1.install "extra/tennis.1"
  end

  test do
    (testpath/"scores.csv").write <<~CSV
      name;score
      Alice;42
      Bob;7
    CSV

    output = shell_output("#{bin}/tennis --color off --delimiter ';' --title Scores #{testpath/"scores.csv"}")
    assert_match "Scores", output
    assert_match "Alice", output
    assert_match "42", output
  end
end
