class Garage < Formula
  desc "S3-compatible object store for small self-hosted geo-distributed deployments"
  homepage "https://garagehq.deuxfleurs.fr/"
  url "https://git.deuxfleurs.fr/Deuxfleurs/garage/archive/v2.1.0.tar.gz"
  sha256 "63b2a0a513464136728bb50a91b40a5911fc25603f3c3e54fe030c01ea5a6084"
  license "AGPL-3.0-only"
  head "https://git.deuxfleurs.fr/Deuxfleurs/garage.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5b9b18fa6475adb4ad97cb02b4219681302704b0b475866bfd0246e2afb5dbb9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2251563d4c279b01001855765ce4b746cfe9fe258bf8a984d565cbb60dade5df"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "81057b549deb91cf68b13890cd65bd171526963c764e06cf77f2c2aba5e0f84e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f7a3c727c43f415df77704b0b83d416be691d7dd419cb6eea2d22fbd186609ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "866ab1ec844e87af80e4e3d382946a4e53a2ce62fb84283035c7b05d2671576c"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "src/garage")
  end

  service do
    run [opt_bin/"garage", "server", "--config", etc/"garage/config.toml"]
    keep_alive true
    working_dir HOMEBREW_PREFIX
    log_path var/"log/garage.log"
    error_log_path var/"log/garage.log"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/garage --version")
    assert_match "Error: Unable to read configuration file", shell_output("#{bin}/garage status 2>&1", 1)
  end
end
