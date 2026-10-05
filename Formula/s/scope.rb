class Scope < Formula
  desc "Serial monitor with scripting support"
  homepage "https://github.com/matheuswhite/scope-rs"
  url "https://github.com/matheuswhite/scope-rs/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "38b960bc5d449a8ccd869e3a6b0b5dd35088310462d1b90a19624eb4c4b4bbf2"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/matheuswhite/scope-rs.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9a8bc03d26ce1481e898cfcdf574fb7d648cdf913e5a6ced51b4659cccc207ef"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a0042480a69aa3b8069c8de98acfa83827c4cf095585ca8e9f4a5c7621c9e299"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "42f96df43a8aece9725f2d72a3ed6f490279088f4f0d015c03bf649a76c2ef08"
    sha256 cellar: :any,                 arm64_linux:   "abe927da4cf2da7abc8a7b22dd2e7fe839edc51988a1d97aec3b93489e841ec9"
    sha256 cellar: :any,                 x86_64_linux:  "565e1880e1562d6b1fdb9fc44ede2c99b1ecb5416429b16b8612e0203939418a"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "systemd"
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"scope", "completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/scope --version")
    output = shell_output("#{bin}/scope --name '' list 2>&1", 1)
    assert_match "session name cannot be empty", output
  end
end
