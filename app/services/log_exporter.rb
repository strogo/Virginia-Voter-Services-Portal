class LogExporter

  def self.export(d1, t1, d2, t2)
    start_date = convert_date(d1, t1)
    end_date   = convert_date(d2, t2)

    records = LogRecord.scoped
    records = records.where([ "created_at >= ?", start_date ]) if start_date
    records = records.where([ "created_at <= ?", end_date ]) if end_date

    puts records.to_xml(only: [ :voter_id, :voter_type, :doctype, :action, :notes, :created_at ])
  end

  private

  def self.convert_date(d, t)
    return nil if d.blank?
    t = '00:01' if t.blank?

    Time.parse([ d, t  ].join(' '))
  end

end