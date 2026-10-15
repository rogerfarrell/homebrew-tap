class BookMockup < Formula
  desc "Render photographic mockups of upright books from flat cover artwork"
  homepage "https://github.com/rogerfarrell/book-mockup"
  url "https://github.com/rogerfarrell/book-mockup/archive/refs/tags/v0.1.1.tar.gz"
  sha256 "342b68a2fc2ca3fae6bbffce897dd336562a53c4eaa5433f7798e5912ab2020f"
  license "GPL-3.0-or-later"
  head "https://github.com/rogerfarrell/book-mockup.git", branch: "main"

  depends_on "pkgconf" => :build
  depends_on "babl"
  depends_on "gegl"
  depends_on "glib"

  def install
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    require "zlib"

    # Writes a solid-color 8-bit RGB PNG, so the test needs no image tools.
    write_png = lambda do |path, width, height, rgb|
      chunk = lambda do |type, data|
        [data.bytesize].pack("N") + type + data +
          [Zlib.crc32(type + data)].pack("N")
      end
      row = ([0] + (rgb * width)).pack("C*")
      header = [width, height, 8, 2, 0, 0, 0].pack("NNCCCCC")
      File.binwrite(path, "\x89PNG\r\n\x1a\n".b +
                          chunk.call("IHDR", header) +
                          chunk.call("IDAT", Zlib::Deflate.deflate(row * height)) +
                          chunk.call("IEND", ""))
    end

    write_png.call(testpath/"cover.png", 60, 90, [30, 60, 160])
    write_png.call(testpath/"spine.png", 9, 90, [20, 30, 60])
    write_png.call(testpath/"back.png", 60, 90, [40, 40, 120])

    system bin/"book-mockup", "-c", testpath/"cover.png",
                              "-s", testpath/"spine.png",
                              "-k", testpath/"back.png",
                              "-W", "240", "-H", "240", "-b", "180",
                              "-f", "600", "-a", "155", "-e", "1.4",
                              "-g", "none", "-o", testpath/"mockup.png"

    assert_path_exists testpath/"mockup.png"
    assert_equal "\x89PNG".b, File.binread(testpath/"mockup.png", 4)
  end
end
