class Simdjzon < Formula
  desc "Simdjson ported to zig"
  homepage "https://github.com/travisstaloch/simdjzon"
  url "https://github.com/travisstaloch/simdjzon/archive/refs/tags/0.15.2.tar.gz"
  sha256 "7b68cb42656e0389b6db3d966e26790e193e9d27f8221e93a0bdaa91bae449ef"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2800362cb789422607117b38066e90382b19c5e04e6495a196e084351082fc18"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cb670a9bf4e0b6f45f78fc426efbd38427a816b03f5693b7111a02e0a79a6d4b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3f4f8199f4eae4347d7e0cfe3754dad7a6daecf52491d4f9efc13cd92fb6adb2"
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
