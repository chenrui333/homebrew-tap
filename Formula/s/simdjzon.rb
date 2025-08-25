class Simdjzon < Formula
  desc "Simdjson ported to zig"
  homepage "https://github.com/travisstaloch/simdjzon"
  url "https://github.com/travisstaloch/simdjzon/archive/refs/tags/0.15.1.tar.gz"
  sha256 "680cc168dce2c5351af94820eae55e982898e36ecba818c6ce78e67863f2da17"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f3c5e1c8bc8545e3b4af965f4afae46ef4dffbfcaaa3ac97f8f11cb33da3ec95"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "95bc3f2b65347f8f4114746181ece6e0ac8468d9c7f2e8cb5f708f7b7eb9c6a1"
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
