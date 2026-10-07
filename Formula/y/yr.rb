class Yr < Formula
  desc "Get the weather delivered to your command-line"
  homepage "https://git.sr.ht/~timharek/yr"
  url "https://git.sr.ht/~timharek/yr/archive/v1.1.0.tar.gz"
  sha256 "cf7b92d980f74278623306f4b715acfd69c629266849f61999570005b3f2cc7e"
  license "GPL-3.0-only"
  head "https://git.sr.ht/~timharek/yr", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c81f61ba2aaf120489831925cb8f7d353083077dac201da02e3950dc5a340f96"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c81f61ba2aaf120489831925cb8f7d353083077dac201da02e3950dc5a340f96"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7c0639b658d605a13cd2f6e995e917a2cfcd688c08b14f63e6eb7b85ebc5db65"
    sha256 cellar: :any,                 x86_64_linux:  "d4fcec269b98b48e69f45ab8d12e28237abc3c79714e757fcdbb2f00c643423e"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=#{version}"), "./cmd/yr"

    generate_completions_from_executable(bin/"yr", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/yr --version")

    # `yr` serves unexpired forecasts from its cache in TMPDIR, skipping Nominatim and MET Norway.
    ENV["TMPDIR"] = testpath.to_s
    now = Time.now.utc
    hour = Time.utc(now.year, now.month, now.day, now.hour)
    forecast = [hour, hour + 3600].map do |time|
      {
        latitude: 40.7127, longitude: -74.006, location: "New York", time: time.iso8601,
        temperature: 14.6, precipitation: 0, wind: { speed: 1.9, direction: 343.5 },
        uvIndex: 0, symbolCode: "fair_night"
      }
    end
    (testpath/"yr-nyc.json").write JSON.generate(
      expires: (now + 86_400).iso8601, lastModified: now.iso8601,
      coordinates: { latitude: 40.7127, longitude: -74.006 }, forecast:
    )

    output = shell_output("#{bin}/yr now nyc")
    assert_match "New York", output
    assert_match "Temperature: 14.6 °C", output
  end
end
