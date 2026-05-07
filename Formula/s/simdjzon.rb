class Simdjzon < Formula
  desc "Simdjson ported to zig"
  homepage "https://github.com/travisstaloch/simdjzon"
  url "https://github.com/travisstaloch/simdjzon/archive/refs/tags/0.16.0.tar.gz"
  sha256 "1d941456a21e2e54f4db7c7bc03d4b303a24e61adf186ecc00d49da7c25bc119"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "aa877277be97ffdd77e092a1efa234ef57fb7d22d1d2e06065f6c5e4db0e6ba0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3766fc20050b8f0421d8d058f928909f9d297097ba4ec6ceeec05c5696da5eb5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "185d0dec6442119f79ec4fdefa85cfa68f760e6ed19cfa7857760eb799164f4c"
  end

  depends_on "zig" => :build
  depends_on arch: :arm64 # builds for arm64 only for now

  def install
    # Fix illegal instruction errors when using bottles on older CPUs.
    # https://github.com/Homebrew/homebrew-core/issues/92282
    cpu = case Hardware.oldest_cpu
    when :arm_vortex_tempest then "apple_m1" # See `zig targets`.
    else Hardware.oldest_cpu
    end

    args = %W[
      --prefix #{prefix}
      -Doptimize=ReleaseSafe
    ]

    args << "-Dcpu=#{cpu}" if build.bottle?
    system "zig", "build", *args
  end

  test do
    (testpath/"test.json").write <<~JSON
      {
          "Width": 800,
          "Height": 600,
          "Title": "View from my room",
          "Url": "http://ex.com/img.png",
          "Private": false,
          "Thumbnail": {
              "Url": "http://ex.com/th.png",
              "Height": 125,
              "Width": 100
          },
          "array": [
              116,
              943,
              234
          ],
          "Owner": null
      }
    JSON

    system bin/"simdjzon", testpath/"test.json"
  end
end
