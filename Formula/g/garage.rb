class Garage < Formula
  desc "S3-compatible object store for small self-hosted geo-distributed deployments"
  homepage "https://garagehq.deuxfleurs.fr/"
  url "https://git.deuxfleurs.fr/Deuxfleurs/garage/archive/v2.1.0.tar.gz"
  sha256 "63b2a0a513464136728bb50a91b40a5911fc25603f3c3e54fe030c01ea5a6084"
  license "AGPL-3.0-only"
  head "https://git.deuxfleurs.fr/Deuxfleurs/garage.git", branch: "main"

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
